class Pastebinit < Formula
  desc "Send things to pastebin from the command-line"
  homepage "https://launchpad.net/pastebinit"
  url "https://launchpad.net/pastebinit/trunk/1.5/+download/pastebinit-1.5.tar.gz"
  sha256 "0d931dddb3744ed38aa2d319dd2d8a2f38a391011ff99db68ce7c83ab8f5b62f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "32b50a7e08ea5699d32046d300c0b76ebbdc78c0b369ab67f65d292b73d09c04" => :sierra
    sha256 "32b50a7e08ea5699d32046d300c0b76ebbdc78c0b369ab67f65d292b73d09c04" => :el_capitan
    sha256 "32b50a7e08ea5699d32046d300c0b76ebbdc78c0b369ab67f65d292b73d09c04" => :yosemite
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
    url = pipe_output("#{bin}/pastebinit -a test -b paste.ubuntu.com", "Hello, world!").chomp
    assert_match "://paste.ubuntu.com/", url
  end
end
