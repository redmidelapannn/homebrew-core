class Oysttyer < Formula
  desc "Command-line Twitter client"
  homepage "https://github.com/oysttyer/oysttyer"
  url "https://github.com/oysttyer/oysttyer/archive/2.7.0.tar.gz"
  sha256 "6b944413423871c6366a3bafd08a79579bce01c6b254df7ebed3394d48c2bb60"

  bottle do
    cellar :any_skip_relocation
    sha256 "9702dd6f0e5fa5c65f0fa3f2d7ba6e1becdff018e0cf429ccadc5a28ec7f59d5" => :el_capitan
    sha256 "cf86f0e5396f23a03b58485a53f268d28ab7402319ae608e603f9e33fb7dbff0" => :yosemite
    sha256 "1099ff0d66b79a1938b2203e9a4af0dc508e6e7562870a6b7b585b271e335e24" => :mavericks
  end

  depends_on "readline" => :optional

  resource "Term::ReadLine::TTYtter" do
    url "https://cpan.metacpan.org/authors/id/C/CK/CKAISER/Term-ReadLine-TTYtter-1.4.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/C/CK/CKAISER/Term-ReadLine-TTYtter-1.4.tar.gz"
    sha256 "ac373133cee1b2122a8273fe7b4244613d0eecefe88b668bd98fe71d1ec4ac93"
  end

  def install
    bin.install "oysttyer.pl" => "oysttyer"

    if build.with? "readline"
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resource("Term::ReadLine::TTYtter").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
      bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
    end
  end

  test do
    IO.popen("#{bin}/oysttyer", "r+") do |pipe|
      assert_equal "-- using SSL for default URLs.", pipe.gets.chomp
      pipe.puts "^C"
      pipe.close_write
    end
  end
end
