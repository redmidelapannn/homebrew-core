class Mkcue < Formula
  desc "Generate a CUE sheet from a CD"
  homepage "https://packages.debian.org/sid/mkcue"
  url "https://deb.debian.org/debian/pool/main/m/mkcue/mkcue_1.orig.tar.gz"
  version "1"
  sha256 "2aaf57da4d0f2e24329d5e952e90ec182d4aa82e4b2e025283e42370f9494867"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "04428c0d5efc4d32dc9ffa394251f7723e19da35870c8c41cdcba403942c55fd" => :mojave
    sha256 "f3dff9e1885d52c0b0767d083b29ab3a1e59a930f550ac566851fce5cc8b0f59" => :high_sierra
    sha256 "16662e1eaa126972566d11c22e5112c9d0aeb0baa98dbb77bb5a55e5f343eb96" => :sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    bin.mkpath
    system "make", "install"
  end

  test do
    touch testpath/"test"
    system "#{bin}/mkcue", "test"
  end
end
