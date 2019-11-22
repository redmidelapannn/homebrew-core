require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/v2.1.3.tar.gz"
  sha256 "6a5b07e06585133bd385632c610f38d0c225a887e1ccb697ab09fec387838976"
  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "669023334332791918686dec295ded210f28136534f5d38a625b9b8901df27f6" => :catalina
    sha256 "b467f260626c68e1121c964b286806e4b31d1fd54dd215747266fc23b3e6beb8" => :mojave
    sha256 "144fc67ddc30e580320af0a27f41062790600b695f36e5d450b691ba9507a7c7" => :high_sierra
  end

  depends_on "cabal-install" => :build
  uses_from_macos "zlib"

  # Stack requires stack to build itself. Yep.
  resource "bootstrap-stack" do
    url "https://github.com/commercialhaskell/stack/releases/download/v2.1.3/stack-2.1.3-osx-x86_64.tar.gz"
    sha256 "84b05b9cdb280fbc4b3d5fe23d1fc82a468956c917e16af7eeeabec5e5815d9f"
  end

  # Stack has very specific GHC requirements.
  # For 2.1.1, it requires 8.4.4.
  resource "bootstrap-ghc" do
    url "https://downloads.haskell.org/~ghc/8.4.4/ghc-8.4.4-x86_64-apple-darwin.tar.xz"
    sha256 "28dc89ebd231335337c656f4c5ead2ae2a1acc166aafe74a14f084393c5ef03a"
  end

  def install
    (buildpath/"bootstrap-stack").install resource("bootstrap-stack")
    ENV.append_path "PATH", "#{buildpath}/bootstrap-stack"

    resource("bootstrap-ghc").stage do
      binary = buildpath/"bootstrap-ghc"

      system "./configure", "--prefix=#{binary}"
      ENV.deparallelize { system "make", "install" }

      ENV.prepend_path "PATH", binary/"bin"
    end

    cabal_sandbox do
      # Let `stack` handle its own parallelization
      # Prevents "install: mkdir ... ghc-7.10.3/lib: File exists"
      jobs = ENV.make_jobs
      ENV.deparallelize

      system "stack", "-j#{jobs}", "--stack-yaml=stack-lts-12.yaml",
             "--system-ghc", "--no-install-ghc", "build"
      system "stack", "-j#{jobs}", "--stack-yaml=stack-lts-12.yaml",
             "--system-ghc", "--no-install-ghc", "--local-bin-path=#{bin}",
             "install"
    end
  end

  test do
    system bin/"stack", "new", "test"
  end
end
