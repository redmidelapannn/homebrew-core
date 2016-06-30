class Cvs2svn < Formula
  desc "Tool for converting from CVS to Subversion"
  homepage "http://cvs2svn.tigris.org/"
  url "http://cvs2svn.tigris.org/files/documents/1462/49237/cvs2svn-2.4.0.tar.gz"
  sha256 "a6677fc3e7b4374020185c61c998209d691de0c1b01b53e59341057459f6f116"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f73e4891b452c7a20a254b8f39cecdf58c45968a313cbabdafa238b09906de4d" => :el_capitan
    sha256 "0a4d79a1fdda7071899f9b828313722ddc46fd80f04e242f7a6d238fcdf26b35" => :yosemite
    sha256 "291f1bad63056439a9ed55dd691261dfabc47cfef0918e181982e4365078c703" => :mavericks
  end

  # cvs2svn requires python with gdbm support
  depends_on "python"

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
    system "make", "man"
    man1.install gzip("cvs2svn.1", "cvs2git.1", "cvs2bzr.1")
    prefix.install %w[ BUGS COMMITTERS HACKING
                       cvs2bzr-example.options
                       cvs2git-example.options
                       cvs2hg-example.options
                       cvs2svn-example.options contrib ]
    doc.install Dir["{doc,www}/*"]
  end

  def caveats; <<-EOS.undent
    NOTE: man pages have been installed, but for better documentation see:
      #{HOMEBREW_PREFIX}/share/doc/cvs2svn/cvs2svn.html
    or http://cvs2svn.tigris.org/cvs2svn.html.

    Contrib scripts and example options files are installed in:
      #{opt_prefix}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cvs2svn --version")
  end
end
