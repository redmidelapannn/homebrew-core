class Unrtf < Formula
  desc "RTF to other formats converter"
  homepage "https://www.gnu.org/software/unrtf/"
  url "https://ftpmirror.gnu.org/unrtf/unrtf-0.21.9.tar.gz"
  mirror "https://ftp.gnu.org/gnu/unrtf/unrtf-0.21.9.tar.gz"
  sha256 "22a37826f96d754e335fb69f8036c068c00dd01ee9edd9461a36df0085fb8ddd"

  head "http://hg.savannah.gnu.org/hgweb/unrtf/", :using => :hg

  bottle do
    revision 1
    sha256 "2d658e54c0f66ae90764c8588fa7181c68d69d505336747b9bd5e496ba7b99d6" => :el_capitan
    sha256 "f4a424591034ed2123c497832782e74d8f5f8276b2b14f36d3852d18e338ec27" => :yosemite
    sha256 "be6cede05f6776838893a1ee743e599820b85458d1f45152450ad0360a4f318d" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "./bootstrap"
    system "./configure", "LIBS=-liconv", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.rtf").write <<-'EOS'.undent
      {\rtf1\ansi
      {\b hello} world
      }
    EOS
    expected = <<-EOS.undent
      <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
      <html>
      <head>
      <meta http-equiv="content-type" content="text/html; charset=utf-8">
      <!-- Translation from RTF performed by UnRTF, version #{version} -->
      </head>
      <body><b>hello</b> world</body>
      </html>
    EOS
    assert_equal expected, shell_output("#{bin}/unrtf --html test.rtf")
  end
end
