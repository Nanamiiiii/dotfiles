{
  lib,
  vfioIds ? null,
  ...
}:
{
  boot = {
    initrd.kernelModules = [
      "vfio_pci"
      "vfio_iommu_type1"
      "vfio"
    ];

    kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
    ] ++ lib.optional (vfioIds != null) ("vfio_pci.ids=" + lib.concatStringsSep "," vfioIds);
  };
}
