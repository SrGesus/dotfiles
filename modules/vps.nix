{
  flake.nixosModules.vps =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      options.modules.vps.domain = lib.mkOption {
        default = "localhost";
        description = "Domain to deploy vps on";
        type = lib.types.str;
      };

      config = {
        services.caddy = {
          enable = true;
          virtualHosts."${config.modules.vps.domain}".extraConfig = ''
            respond "Hello, world!"
          '';
          virtualHosts."couchdb.${config.modules.vps.domain}".extraConfig = ''
            reverse_proxy localhost:${toString config.services.couchdb.port}
          '';
          globalConfig = ''
            admin off
          '';
        };

        sops.secrets."couchdb.ini" = {
          sopsFile = ../secrets/vps.yaml;
          owner = config.services.couchdb.user;
          group = config.services.couchdb.group;
        };
        services.couchdb = {
          enable = true;

          # Admin credentials
          configFile = config.sops.secrets."couchdb.ini".path;

          extraConfig = {
            couchdb.max_document_size = 50000000;
            chttpd = {
              bind_address = "127.0.0.1";
              enable_cors = true;
              require_valid_user = true;
              max_http_request_size = 4294967296;
            };
            httpd = {
              WWW-Authenticate = ''Basic realm="couchdb"'';
            };
            cluster.n = 1;
            cors = {
              origins = "*";
              methods = "GET, PUT, POST, HEAD, DELETE";
              credentials = true;
              headers = "accept, authorization, content-type, origin, referer";
            };
          };
        };

        networking.firewall.allowedTCPPorts = [
          80
          443
        ];
      };
    };
}
