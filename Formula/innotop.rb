class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://github.com/innotop/innotop/archive/v1.11.tar.gz"
  sha256 "f59430d1cbbe5d9e67dc225d21aeb5611ba9a2a53d3399d1c19c595646617226"
  head "https://github.com/innotop/innotop.git"

  bottle do
    cellar :any
    sha256 "6f4c1f8c3b77ef61d6aa710e35c93704789252bab8082a6e0d67438b7a60f980" => :el_capitan
    sha256 "8a43fff2ecf89adcd9a3098239291dd8dad0780e51bdfbbc1789c270eb7d7144" => :yosemite
    sha256 "43a29ed882bb0cb9ab17f5f2bc492e328ce336675489c5eaad17f5a9f3f2f147" => :mavericks
  end

  depends_on :mysql
  depends_on "openssl"

  conflicts_with "mytop", :because => "both install `perllocal.pod`"

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.033.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.033.tar.gz"
    sha256 "cc98bbcc33581fbc55b42ae681c6946b70a26f549b3c64466740dfe9a7eac91c"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    # Fix the version
    # Reported 14 Jun 2016: https://github.com/innotop/innotop/issues/139
    inreplace "innotop", "1.10", version

    resource("DBD::mysql").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make", "install"
    share.install prefix/"man"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    # Calling commands throws up interactive GUI, which is a pain.
    assert_match version.to_s, shell_output("#{bin}/innotop --version")
  end
end
