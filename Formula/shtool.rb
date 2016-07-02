class Shtool < Formula
  desc "GNU's portable shell tool"
  homepage "https://www.gnu.org/software/shtool/"
  url "https://ftpmirror.gnu.org/shtool/shtool-2.0.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/shtool/shtool-2.0.8.tar.gz"
  sha256 "1298a549416d12af239e9f4e787e6e6509210afb49d5cf28eb6ec4015046ae19"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "d574d552b11a535505c7db3dba2fb747946e96579b4fa7cb45dbe5b72f6bb900" => :el_capitan
    sha256 "867f4e2c3cad9dfd5533dc72c4b7a1aa6318d27e0cc767b0c749bc3c995c9b9f" => :yosemite
    sha256 "db51cbc2064692afb279f583c97693a6c35b7847fd12e45b1695d503a3bc7ea2" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/shtool echo 'Hello World!'").chomp
  end
end
