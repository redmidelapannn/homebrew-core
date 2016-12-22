require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/releases/download/v1.3.0/stack-1.3.0-sdist-0.tar.gz"
  version "1.3.0"
  sha256 "487263501d09d4977040670eaf5e6798efac33a26b48dc57c031fc181405950e"
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "60bccbb30a4652fbd6f379c5eab03ae97c54fb9b1fd0dccf815f4d65b3b4984b" => :el_capitan
    sha256 "00e99cee0c73648034279ca9cbda0810258bc6d3a4d8b76a0a78d9f2ca5ae9e0" => :yosemite
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
      system "cabal", "get", "Glob", "hpc"
      inreplace "Glob-0.7.13/Glob.cabal", ", directory    <  1.3",
                                          ", directory    <  1.4"
      inreplace "hpc-0.6.0.3/hpc.cabal", "directory  >= 1.1   && < 1.3,",
                                         "directory  >= 1.1   && < 1.4,"
      cabal_sandbox_add_source "Glob-0.7.13", "hpc-0.6.0.3"

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
    rpaths = Utils.popen_read("otool -l #{bin}/stack").split("\n")
    rpaths = rpaths.inject([]) do |r, e|
      if e =~ /^ +path (.*) \(offset.*/
        r << $~[1]
      else
        r
      end
    end
    rpaths.each do |r|
      system "install_name_tool", "-delete_rpath", r, bin/"stack"
    end
  end

  test do
    system bin/"stack", "new", "test"
  end
end
