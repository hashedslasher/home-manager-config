final: prev: {
 # Replace 'zennotes' with the actual package name if it differs 
 # (e.g., it might be prev.zennotes-desktop)
 zennotes = prev.zennotes.overrideAttrs (oldAttrs: {
   
   # Ensure makeWrapper is available during the build
   nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ prev.makeWrapper ];

   # Run after the package is installed to wrap the binary
   postFixup = (oldAttrs.postFixup or "") + ''
     wrapProgram $out/bin/zennotes-desktop \
       --prefix LD_LIBRARY_PATH : "${prev.libGL}/lib"
   '';
 });
}
