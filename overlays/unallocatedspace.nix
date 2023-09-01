{ self, system, ... }:
f: p: {
  unallocatedspace-frontend = self.packages.${system}.unallocatedspace-frontend;
}
