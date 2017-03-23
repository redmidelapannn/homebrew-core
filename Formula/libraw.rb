class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.17.2.tar.gz"
  mirror "https://fossies.org/linux/privat/LibRaw-0.17.2.tar.gz"
  mirror "https://distfiles.macports.org/libraw/LibRaw-0.17.2.tar.gz"
  sha256 "92b0c42c7666eca9307e5e1f97d6fefc196cf0b7ee089e22880259a76fafd15c"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "468529c0cd1aa1022a03212b23466b0a140774dc980d5e9dc9c71d093dd19cb8" => :sierra
    sha256 "9692d24bc5a38cc4f82a66c4009f98057c8bc4d2ca5286a9569f27d3faaa802c" => :el_capitan
    sha256 "3e0ffe4c424f10304806cc3c2a0a83032b4b954a83fcc9cd7bb758123f40c121" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "little-cms2"

  resource "librawtestfile" do
    url "https://www.rawsamples.ch/raws/nikon/d1/RAW_NIKON_D1.NEF",
      :using => :nounzip
    sha256 "7886d8b0e1257897faa7404b98fe1086ee2d95606531b6285aed83a0939b768f"
  end

  resource "gpl2" do
    url "https://www.libraw.org/data/LibRaw-demosaic-pack-GPL2-0.17.2.tar.gz"
    mirror "https://distfiles.macports.org/libraw/LibRaw-demosaic-pack-GPL2-0.17.2.tar.gz"
    sha256 "a2e5e9cc04fa8f3e94070110dce8a06aa3b0b2f573ed99c5fc3e327d15f014b7"
  end

  resource "gpl3" do
    url "https://www.libraw.org/data/LibRaw-demosaic-pack-GPL3-0.17.2.tar.gz"
    mirror "https://distfiles.macports.org/libraw/LibRaw-demosaic-pack-GPL3-0.17.2.tar.gz"
    sha256 "b00cd0f54851bd3c8a66be4cacbf049e4508f1bac8ff85cb4528d8979739ed36"
  end

  def install
    %w[gpl2 gpl3].each { |f| (buildpath/f).install resource(f) }
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-demosaic-pack-gpl2=#{buildpath}/gpl2",
                          "--enable-demosaic-pack-gpl3=#{buildpath}/gpl3"
    system "make"
    system "make", "install"
    doc.install Dir["doc/*"]
    prefix.install "samples"
  end

  test do
    resource("librawtestfile").stage do
      filename = "RAW_NIKON_D1.NEF"
      system "#{bin}/raw-identify", "-u", filename
      system "#{bin}/simple_dcraw", "-v", "-T", filename
    end
  end
end
