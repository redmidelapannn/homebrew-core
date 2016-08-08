class Owfs < Formula
  desc "Monitor and control physical environment using Dallas/Maxim 1-wire system"
  homepage "http://owfs.org/"
  url "https://downloads.sourceforge.net/project/owfs/owfs/3.1p2/owfs-3.1p2.tar.gz"
  version "3.1p2"
  sha256 "82ddc4c40d32d4f4f4b09fd57711d0892281680d9cb3e9cfa96927acd593cfe3"

  bottle do
    cellar :any
    sha256 "d1cedce75605a9f7f08799b5c9a221f96896f88da09c439a234094d7755e0ad1" => :el_capitan
    sha256 "0a0d6bd1534df30724e7b9b48cf3bdc103772d7f8de6d4050ec53a29d0160ef4" => :yosemite
    sha256 "44ec9c181386a5537ba6a8767fa1768744c51123e5091e215a9bb16ccb635428" => :mavericks
  end

  depends_on "libusb"

  # "libusb.h" and "ow_ftdi.h" are missing from the release tarball
  # install them as a resource to avoid building from the tag with Autotools
  # Reported 8 Aug 2016: https://sourceforge.net/p/owfs/bugs/70/
  resource "missing_includes" do
    url "git://git.code.sf.net/p/owfs/code",
        :tag => "v3.1p2",
        :revision => "eb05fc0fd388b2de0d501022a1d1e66e1167991a"
  end

  def install
    resource("missing_includes").stage do
      missing = Dir["module/owlib/src/include/{libusb.h,ow_ftdi.h}"]
      cp missing, buildpath/"module/owlib/src/include"

      # prevent automake from being triggered
      touch missing, :mtime => (buildpath/"module/owlib/src").mtime
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-swig",
                          "--disable-owfs",
                          "--disable-owtcl",
                          "--disable-zero",
                          "--disable-owpython",
                          "--disable-owperl",
                          "--disable-ftdi",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"owserver", "--version"
  end
end
