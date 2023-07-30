{ self, system, ... }:

(final: prev: {
  unallocatedspace-frontend = self.packages.${system}.unallocatedspace-frontend;
})
