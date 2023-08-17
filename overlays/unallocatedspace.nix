{ self, system, ... }:
{
  unallocatedspace-frontend = self.packages.${system}.unallocatedspace-frontend;
}
