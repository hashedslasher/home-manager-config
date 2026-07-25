final: prev: {
  # We overwrite the default 'spyder' package with our custom wrapped version
  spyder = let
    # 1. Bundle Spyder, the kernels, and all plugins/data science libs in one environment
    spyderEnv = prev.python3.withPackages (ps: with ps; [
      spyder
      spyder-kernels
      ipython
      python-lsp-server
      python-lsp-black
      jedi
      black
      autopep8
      matplotlib
      pandas
      numpy
      scipy
      
      # Assuming inputs is available in your overlay scope:
      # (inputs.yannix.packages.${prev.system}."python.spyder-vim".override { python3 = prev.python3; })
    ]);
  in prev.symlinkJoin {
    name = "spyder-wrapped";
    paths = [ spyderEnv ];
    nativeBuildInputs = [ prev.makeWrapper ];
    
    postBuild = ''
      # 2. Delete all symlinks in /bin to hide `python`, `black`, etc. from your terminal
      rm -rf $out/bin/*
      
      # 3. Create a new wrapper specifically for Spyder, injecting your Qt fixes
      makeWrapper ${spyderEnv}/bin/spyder $out/bin/spyder \
        --set QT_QPA_PLATFORM xcb \
        --set QT_XCB_GL_INTEGRATION none \
        --set QTWEBENGINE_DISABLE_GPU 1
    '';
  };
}
