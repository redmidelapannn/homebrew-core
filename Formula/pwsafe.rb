class Pwsafe < Formula
  desc "Generate passwords and manage encrypted password databases"
  homepage "http://nsd.dyndns.org/pwsafe/"
  url "http://nsd.dyndns.org/pwsafe/releases/pwsafe-0.2.0.tar.gz"
  mirror "https://src.fedoraproject.org/repo/pkgs/pwsafe/pwsafe-0.2.0.tar.gz/4bb36538a2772ecbf1a542bc7d4746c0/pwsafe-0.2.0.tar.gz"
  sha256 "61e91dc5114fe014a49afabd574eda5ff49b36c81a6d492c03fcb10ba6af47b7"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "4ce3e48c4afaf130598b3c4bc19dc9d46e0a4eedd0b4256c3258113ae8134445" => :high_sierra
    sha256 "177f4dfd04d012bb33a8822caaa58d96a7323f39cd40b21d75c43bad0d93ab8c" => :sierra
    sha256 "0cca355dafb40d5f69f855fb372914208361908f1a7a06e1f7d4cfff13e9617f" => :el_capitan
  end

  depends_on "openssl"
  depends_on "readline"

  # A password database for testing is provided upstream. How nice!
  resource "test-pwsafe-db" do
    url "http://nsd.dyndns.org/pwsafe/test.dat"
    mirror "https://raw.githubusercontent.com/nsd20463/pwsafe/208de3a94339df36b6e9cd8aeb7e0be0a67fd3d7/test.dat"
    sha256 "7ecff955871e6e58e55e0794d21dfdea44a962ff5925c2cd0683875667fbcc79"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    test_db_passphrase = "abc"
    test_account_name = "testing"
    test_account_pass = "sg1rIWHL?WTOV=d#q~DmxiQq%_j-$f__U7EU"

    resource("test-pwsafe-db").stage do
      Utils.popen(
        "#{bin}/pwsafe -f test.dat -p #{test_account_name}", "r+"
      ) do |pipe|
        pipe.puts test_db_passphrase
        assert_match(/^#{Regexp.escape(test_account_pass)}$/, pipe.read)
      end
    end
  end
end
