class Vit < Formula
  desc "Front-end for Task Warrior"
  homepage "https://taskwarrior.org/news/news.20140406.html"
  url "https://taskwarrior.org/download/vit-1.2.tar.gz"
  sha256 "a78dee573130c8d6bc92cf60fafac0abc78dd2109acfba587cb0ae202ea5bbd0"
  revision 1
  head "https://github.com/scottkosty/vit.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6c19c6c0b7bada094dd7cb046a4e14450a37632fa5248f4f30b44d980af840d5" => :high_sierra
    sha256 "56901db83d2721e9e40b33a04f9942be396762bb58b590945bfbd6ffd1393803" => :sierra
    sha256 "42a61d1bfad397d0ad8c07e9278d659ae38f341e72e00ba1874bf6e78df8defe" => :el_capitan
  end

  depends_on "task"

  resource "Curses" do
    url "https://cpan.metacpan.org/authors/id/G/GI/GIRAFFED/Curses-1.31.tgz"
    sha256 "7bb4623ac97125c85e25f9fbf980103da7ca51c029f704f0aa129b7a2e50a27a"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resource("Curses").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "build"

    bin.install "vit"
    man1.install "vit.1"
    man5.install "vitrc.5"
    # vit-commands needs to be installed in the keg because that's where vit
    # will look for it.
    (prefix+"etc").install "commands" => "vit-commands"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end
end
