class Admesh < Formula
  desc "Processes triangulated solid meshes"
  homepage "https://github.com/admesh/admesh"
  url "https://github.com/admesh/admesh/releases/download/v0.98.2/admesh-0.98.2.tar.gz"
  sha256 "ae34a6f42136a434ae242dcd76415dca326ecd1fe55bbd253bb56318ceee382b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "851a7f09b16e05d1033aeea008c62bd949563183c9d521e53ea20ab3bcc7ec59" => :sierra
    sha256 "fa703e7bcfcf38577afe2904e1a8c242728c0bd991b8188dd9be2a28f411057f" => :el_capitan
    sha256 "427f6068e655ae9114d41af5309dee891e4c3b4aea21ded89a19b1f77c7a9048" => :yosemite
  end

  head do
    url "https://github.com/admesh/admesh.git"

    depends_on "libtool"  => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Test file is the beginning of block.stl from admesh's source
    (testpath/"test.stl").write <<-EOS.undent
      SOLID Untitled1
      FACET NORMAL  0.00000000E+00  0.00000000E+00  1.00000000E+00
      OUTER LOOP
      VERTEX -1.96850394E+00  1.96850394E+00  1.96850394E+00
      VERTEX -1.96850394E+00 -1.96850394E+00  1.96850394E+00
      VERTEX  1.96850394E+00 -1.96850394E+00  1.96850394E+00
      ENDLOOP
      ENDFACET
      ENDSOLID Untitled1
    EOS
    system "#{bin}/admesh", "test.stl"
  end
end
