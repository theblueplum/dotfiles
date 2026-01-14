{
    pkgs ? import <nixpkgs> { },
}:

pkgs.buildGoModule {
    name = "leveldb-cli";
    version = "1.0.0";

    src = pkgs.fetchFromGitHub {
        owner = "theblueplum";
        repo = "leveldb-cli";
        rev = "main";
        hash = "sha256-Q4BVmmqc6MPrOLy/lSV1FyhAoKBq0U2UcMHYEMOhtpo=";
    };

    vendorHash = "sha256-b25hlPQft9iKyIw6E9jtORBgoLPnNa4+Z5QoeFoayfc=";

    meta = {
        mainProgram = "leveldb";
    };
}
