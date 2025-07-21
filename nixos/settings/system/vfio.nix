{
  lib,
  vfioIds ? null,
  ...
}:
{
  boot = {
    initrd.availableKernelModules = [
      "pci_stub"
      "vfio_pci"
      "vfio_iommu_type1"
      "vfio"
    ];

    # fix for module load order
    extraModprobeConfig = ''
      softdep nvidia pre: pci_stub vfio vfio_iommu_type1 vfio_pci
    '';

    kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
    ]
    ++ lib.optional (vfioIds != null) ("vfio_pci.ids=" + lib.concatStringsSep "," vfioIds);
  };
}
