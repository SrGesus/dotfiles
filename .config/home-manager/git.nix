{config, pkgs, ...}:
{
    home.packages = [
        pkgs.git
    ];

    programs.git = {
        enable = true;
        userName = "SrGesus";
        userEmail = "108523575+SrGesus@users.noreply.github.com";
    };
}