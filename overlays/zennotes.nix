final: prev: {
  zennotes = prev.zennotes.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ prev.makeWrapper ];
    
    postFixup = (old.postFixup or "") + ''
      wrapProgram $out/bin/zennotes-desktop \
        --prefix LD_LIBRARY_PATH : "${prev.libGL}/lib:${prev.libglvnd}/lib"
    '';
  });
}
