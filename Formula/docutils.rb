class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.16/docutils-0.16.tar.gz"
  sha256 "7d4e999cca74a52611773a42912088078363a30912e8822f7a3d38043b767573"

  bottle do
    cellar :any_skip_relocation
    sha256 "3230d98f9912c462a2b6dd1aa64494fa26037eec4c1975a75970361de6243e79" => :catalina
    sha256 "c655dd3f311370b4c6683236b6ead52d800397e050584124a54709effa556746" => :mojave
    sha256 "7fc8102f9f46d9f3bc4debe405fa6b533809aa73da074d0379652971a30fbd93" => :high_sierra
    sha256 "6393cc30ff4cef96e4309fc912267fd9649396fc31a471b15af6363eb1cedf95" => :sierra
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/rst2man.py", "#{prefix}/HISTORY.txt"
  end
end
