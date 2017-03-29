class Pastebinit < Formula
  desc "Send things to pastebin from the command-line"
  homepage "https://launchpad.net/pastebinit"
  url "https://launchpad.net/pastebinit/trunk/1.5/+download/pastebinit-1.5.tar.gz"
  sha256 "0d931dddb3744ed38aa2d319dd2d8a2f38a391011ff99db68ce7c83ab8f5b62f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "808099e1492f7116eb6851e72bb57e4a6b8790ec68ffbf48006b34d0e95952d1" => :sierra
    sha256 "808099e1492f7116eb6851e72bb57e4a6b8790ec68ffbf48006b34d0e95952d1" => :el_capitan
    sha256 "808099e1492f7116eb6851e72bb57e4a6b8790ec68ffbf48006b34d0e95952d1" => :yosemite
  end

  depends_on "docbook2x" => :build
  depends_on "python3"

  def install
    inreplace "pastebinit" do |s|
      s.gsub! "/usr/bin/python3", Formula["python3"].opt_bin/"python3"
      s.gsub! "/usr/local/etc/pastebin.d", etc/"pastebin.d"
    end

    system "docbook2man", "pastebinit.xml"
    bin.install "pastebinit"
    etc.install "pastebin.d"
    man1.install "PASTEBINIT.1" => "pastebinit.1"
    libexec.install %w[po utils]
  end

  test do
    text = "Hello, world!"
    # Returned URL is cleartext as of 2017-03
    url = pipe_output("#{bin}/pastebinit -a test -b paste.ubuntu.com", text).chomp
    url.sub! "http:", "https:"
    assert_match text, shell_output("curl " + url)
  end
end
