class PerconaToolkit < Formula
  desc "Percona Toolkit for MySQL"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.0.9/source/tarball/percona-toolkit-3.0.9.tar.gz"
  sha256 "1b66fbd0e3427a189980d4c02897da1444ffd2cf40156142728ee7e5cd97be88"
  head "lp:percona-toolkit", :using => :bzr

  bottle do
    cellar :any
    rebuild 1
    sha256 "e97743fe7f3f1be89cec7e37389a0e50897645a05fee1271999ed62095983764" => :high_sierra
    sha256 "67d42b6b0d40c7ed11bef002dfa1d56c8ebe90910560ab6cf9d6516b28bc9d05" => :sierra
    sha256 "0a88a389b9c66875cda29113f4bd774633e5979a5d91cf502c77ee275f6a53cd" => :el_capitan
  end

  depends_on "mysql"
  depends_on "openssl"

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.046.tar.gz"
    sha256 "6165652ec959d05b97f5413fa3dff014b78a44cf6de21ae87283b28378daf1f7"
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-2.97001.tar.gz"
    sha256 "e277d9385633574923f48c297e1b8acad3170c69fa590e31fa466040fc6f8f5a"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make", "test", "install"
    share.install prefix/"man"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    input = "SELECT name, password FROM user WHERE id='12823';"
    output = pipe_output("#{bin}/pt-fingerprint", input, 0)
    assert_equal "select name, password from user where id=?;", output.chomp
  end
end
