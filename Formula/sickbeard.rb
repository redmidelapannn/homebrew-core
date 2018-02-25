class Sickbeard < Formula
  desc "PVR application to search and manage TV shows"
  homepage "http://www.sickbeard.com/"
  url "https://github.com/midgetspy/Sick-Beard/archive/build-507.tar.gz"
  sha256 "eaf95ac78e065f6dd8128098158b38674479b721d95d937fe7adb892932e9101"
  head "https://github.com/midgetspy/Sick-Beard.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "77868ceda6a36fd9a483a0e54d1965406708bc972c1ba06328d574bd04c462e4" => :high_sierra
    sha256 "9c2db2b8ae7e827a3309459eec5c8431eca5fda18c0b3823c97065ab7a8eab97" => :sierra
    sha256 "bd5b5a8070feab81ded15a8f4bc32672440b54ed2e726dffb9ec91e8ce2e840d" => :el_capitan
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/source/M/Markdown/Markdown-2.4.1.tar.gz"
    sha256 "812ec5249f45edc31330b7fb06e52aaf6ab2d83aa27047df7cb6837ef2d269b6"
  end

  resource "Cheetah" do
    url "https://files.pythonhosted.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end

  def install
    # TODO: - strip down to the minimal install
    prefix.install_metafiles
    libexec.install Dir["*"]

    ENV["CHEETAH_INSTALL_WITHOUT_SETUPTOOLS"] = "1"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    install_args = ["setup.py", "install", "--prefix=#{libexec}"]

    resource("Markdown").stage { system "python", *install_args }
    resource("Cheetah").stage { system "python", *install_args }

    (bin+"sickbeard").write(startup_script)
  end

  def caveats
    "SickBeard defaults to port 8081."
  end

  plist_options :manual => "sickbeard"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/sickbeard</string>
        <string>-q</string>
        <string>--nolaunch</string>
        <string>-p</string>
        <string>8081</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  def startup_script; <<~EOS
    #!/bin/bash
    export PYTHONPATH="#{libexec}/lib/python2.7/site-packages:$PYTHONPATH"
    python "#{libexec}/SickBeard.py"\
           "--pidfile=#{var}/run/sickbeard.pid"\
           "--datadir=#{etc}/sickbeard"\
           "$@"
    EOS
  end
end
