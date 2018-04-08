class Archivemail < Formula
  desc "Tool for archiving and compressing old email in mailboxes"
  homepage "https://archivemail.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/archivemail/archivemail-0.9.0.tar.gz"
  sha256 "4b430e2fba6f24970a67bd61eef39d7eae8209c7bef001196b997be1916fc663"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "be49a35761dc543dc70fd386315ab01b2f2c92cd2c9c91301c643369c1627658" => :high_sierra
    sha256 "be49a35761dc543dc70fd386315ab01b2f2c92cd2c9c91301c643369c1627658" => :sierra
    sha256 "be49a35761dc543dc70fd386315ab01b2f2c92cd2c9c91301c643369c1627658" => :el_capitan
  end

  depends_on "python@2"

  def install
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    man1.install Dir[libexec/"share/man/man1/*"]
  end

  test do
    (testpath/"inbox").write <<~EOS
      From MAILER-DAEMON Fri Jul  8 12:08:34 2011
      From: Author <author@example.com>
      To: Recipient <recipient@example.com>
      Subject: Sample message 1

      This is the body.

      From MAILER-DAEMON Fri Jul  8 12:08:34 2012
      From: Author <author@example.com>
      To: Recipient <recipient@example.com>
      Subject: Sample message 2

      This is the second body.
    EOS
    system bin/"archivemail", "--no-compress", "--date", "2012-01-01", (testpath/"inbox")
    assert_predicate testpath/"inbox_archive", :exist?
    assert_match "Sample message 1", File.read("inbox_archive")
    assert !File.read("inbox").include?("Sample message 1")
    assert_match "Sample message 2", File.read("inbox")
  end
end
