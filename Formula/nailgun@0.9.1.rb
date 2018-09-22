class NailgunAT091 < Formula
  desc "Command-line client, protocol and server for Java programs"
  homepage "http://www.martiansoftware.com/nailgun/"
  url "https://github.com/martylamb/nailgun/archive/nailgun-all-0.9.1.tar.gz"
  sha256 "c487735b07f3d65e4c4d9bfa9aaef86d0d78128e4c055c6c24da818a4a47b2ab"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb65fefa6998676e7fb489a0afe326ca58135a32c6714b75523590c0f845acb5" => :mojave
    sha256 "4d28569b300f27611da2252c337c5a9877f2c4eac4106b23e24552020fcbb28d" => :high_sierra
    sha256 "82d444ba584de0838a9f70924c87344e07073642944b4b5dd7fbbc6044a633d2" => :sierra
    sha256 "e90cf398cdda7bda8fde4ebef0639a9c1f25f830b531ea36eb48d8d3ec47c10b" => :el_capitan
  end

  resource "nailgun-jar" do
    url "https://search.maven.org/remotecontent?filepath=com/martiansoftware/nailgun-server/0.9.1/nailgun-server-0.9.1.jar"
    sha256 "4518faa6bf4bd26fccdc4d85e1625dc679381a08d56872d8ad12151dda9cef25"
  end

  # This patch just prepares the way for the next one.
  patch do
    url "https://github.com/martylamb/nailgun/commit/a789fa3f4eefcd24018d4fd89fc9037427533f52.diff?full_index=1"
    sha256 "7beb0f392ff498a28cfe11af4d6b0be2759c7e27262c944e385c7e9e52ae9db4"
  end

  # The makefile is not prefix aware
  patch do
    url "https://github.com/martylamb/nailgun/pull/45.diff?full_index=1"
    sha256 "59edcba5eb804ae0eec4520a1b4aa26eb595ebfd6f8adce663bfa0fa15a563e2"
  end

  def install
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}", "CFLAGS=#{ENV.cflags}"
    jar_version=version
    libexec.install resource("nailgun-jar").files("nailgun-server-#{version}.jar")
    bin.write_jar_script libexec/"nailgun-server-#{jar_version}.jar", "ng-server", "-server"
  end

  test do
    fork { exec "ng-server", "8765" }
    sleep 1 # the server does not begin listening as fast as we can start a background process
    system "#{bin}/ng", "--nailgun-port", "8765", "ng-version"
    Kernel.system "#{bin}/ng", "--nailgun-port", "8765", "ng-stop"
    # ng-stop always returns a non-zero exit code even on successful exit
    true
  end
end
