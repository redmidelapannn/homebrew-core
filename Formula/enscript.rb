class Enscript < Formula
  desc "Convert text to Postscript, HTML, or RTF, with syntax highlighting"
  homepage "https://www.gnu.org/software/enscript/"
  url "https://ftpmirror.gnu.org/enscript/enscript-1.6.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/enscript/enscript-1.6.6.tar.gz"
  sha256 "6d56bada6934d055b34b6c90399aa85975e66457ac5bf513427ae7fc77f5c0bb"

  head "https://git.savannah.gnu.org/git/enscript.git"

  bottle do
    rebuild 2
    sha256 "6f79da7f219e15525c117717cbe1f698e90ac5be82f59aca4f7a1fcd8d06b2a0" => :sierra
    sha256 "2a9ee4bb79f060ed09627b5227c5d2f5a289d6c9dea73ac1a48826789805e144" => :el_capitan
    sha256 "c9f4fe97b3d4133cb19187bf27d1c7e5d3ae6b427c16926f698a7a05d33c7391" => :yosemite
  end

  keg_only :provided_pre_mountain_lion

  depends_on "gettext"

  conflicts_with "cspice", :because => "both install `states` binaries"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /GNU Enscript #{Regexp.escape(version)}/,
                 shell_output("#{bin}/enscript -V")
  end
end
