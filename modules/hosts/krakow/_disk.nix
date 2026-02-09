{lib, ...}: {
disko.devices = {
    disk.disk1 = {
      device = lib.mkDefault "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
          swap = {
            size = "8G";
            content = {
              type = "swap";
              priority = 100;
            };
          };
        };
      };
    };
  };

  # disko.devices = {
  #   disk.disk1 = {
  #     device = "/dev/sda";
  #     type = "disk";
  #     content = {
  #       type = "gpt";
  #       partitions = {
  #         ESP = {
  #           size = "500M";
  #           type = "EF00";
  #           content = {
  #             type = "filesystem";
  #             format = "vfat";
  #             mountpoint = "/boot";
  #             mountOptions = [ "umask=0077" ];
  #           };
  #         };
  #         root = {
  #           size = "100%";
  #           content = {
  #             type = "filesystem";
  #             format = "ext4";
  #             mountpoint = "/";
  #           };
  #         };
  #         swap = {
  #           size = "8G";
  #           content = {
  #             type = "swap";
  #             priority = 100;
  #           };
  #         };
  #       };
  #     };
  #   };
  # };
}
