require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/releases/download/v1.3.2/stack-1.3.2-sdist-0.tar.gz"
  version "1.3.2"
  sha256 "369dfaa389b373e6d233b5920d071f717b10252279e6004be2c6c4e3cd9488d4"
  revision 1
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "79d387a26f77dfd0291aa6c9ea92cef0379d7804a6549033f4af5781956d4ee3" => :el_capitan
    sha256 "5b485696931af0e4db5017ff276eb696b139f88dbba74c1710166243df782323" => :yosemite
  end

  option "without-bootstrap", "Don't bootstrap a stage 2 stack"

  # malformed mach-o: load commands size (40192) > 32768
  depends_on MaximumMacOSRequirement => :el_capitan if build.bottle?

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    if MacOS.version >= :sierra && build.with?("bootstrap")
      raise <<-EOS.undent
        stack cannot build with bootstrap on Sierra due to an upstream GHC
        incompatiblity. Please use the pre-built bottle binary instead of attempting to
        build from source or pass --without-bootstrap. For more details see
          https://ghc.haskell.org/trac/ghc/ticket/12479
          https://github.com/commercialhaskell/stack/issues/2577
      EOS
    end

    cabal_sandbox do
      inreplace "stack.cabal", "directory >=1.2.1.0 && <1.3,",
                               "directory >=1.2.1.0 && <1.4,"
      system "cabal", "get", "hpc"
      inreplace "hpc-0.6.0.3/hpc.cabal", "directory  >= 1.1   && < 1.3,",
                                         "directory  >= 1.1   && < 1.4,"
      cabal_sandbox_add_source "hpc-0.6.0.3"

      if build.with? "bootstrap"
        cabal_install
        # Let `stack` handle its own parallelization
        # Prevents "install: mkdir ... ghc-7.10.3/lib: File exists"
        jobs = ENV.make_jobs
        ENV.deparallelize do
          system "stack", "-j#{jobs}", "setup"
          system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install"
        end
      else
        install_cabal_package
      end
    end

    # Remove the unneeded rpaths so that the binary works on Sierra
    macho = MachO.open("#{bin}/stack")
    macho.rpaths.each do |rpath|
      macho.delete_rpath(rpath)
    end
    macho.write!
  end

  test do
    system bin/"stack", "new", "test"
  end
end
