class Unfs3 < Formula
  desc "User-space NFSv3 server"
  homepage "http://unfs3.sourceforge.net"
  url "https://downloads.sourceforge.net/project/unfs3/unfs3/0.9.22/unfs3-0.9.22.tar.gz"
  sha256 "482222cae541172c155cd5dc9c2199763a6454b0c5c0619102d8143bb19fdf1c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3d6fab09863408c11818c4dddd0bdeeff541a049d0424159c4608ce1e2be8600" => :sierra
    sha256 "512b4de52f86a7ad3722e07600eae953e3f4e7acc9b6ba6d51a3bbe744a7dfd0" => :el_capitan
    sha256 "fe74a2822bd0d797738327cc4c1a6e6794fc82aee87451ff467ed2a74c61df56" => :yosemite
  end

  head do
    url "http://svn.code.sf.net/p/unfs3/code/trunk/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    ENV.j1 # Build is not parallel-safe
    system "./bootstrap" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"exports").write <<-EOS.undent
    "#{Dir.pwd}" 192.168.0.1(ro)
    EOS
    system("#{sbin}/unfsd", "-T", "-e", (testpath/"exports").to_s)
  end
end
