final: prev: {
  foliate = prev.foliate.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ prev.makeWrapper ];
    postFixup = ''
      ${old.postFixup or ""}
      wrapProgram "$out/bin/foliate" --set GDK_BACKEND x11
    '';
  });
}
