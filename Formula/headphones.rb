class Headphones < Formula
  desc "Automatic music downloader for SABnzbd"
  homepage "https://github.com/rembo10/headphones"
  url "https://github.com/rembo10/headphones/archive/v0.5.19.tar.gz"
  sha256 "604365d356c2079bd55955aa8448a70c39cc5f32a71049a49876847423ce5d12"
  head "https://github.com/rembo10/headphones.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4c133420b9e1ecc3355f35ccdfa3f87dc66aa2ba1467f2e6a63a0eb7d4f434a5" => :high_sierra
    sha256 "4ee5b2b08ad5b689d238032ed67e10c6ea1f61c44111ed5fa8bf6888d5feb0cd" => :sierra
    sha256 "54fab5f6e84e299abbad303fda9af6a17ad031e31c4b75fbd68e416de7be582b" => :el_capitan
  end

  depends_on "python@2"

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/b3/73/fc5c850f44af5889192dff783b7b0d8f3fe8d30b65c8e3f78f8f0265fecf/Markdown-2.6.11.tar.gz"
    sha256 "a856869c7ff079ad84a3e19cd87a64998350c2b94e9e08e44270faef33400f81"
  end

  resource "Cheetah" do
    url "https://files.pythonhosted.org/packages/cd/b0/c2d700252fc251e91c08639ff41a8a5203b627f4e0a2ae18a6b662ab32ea/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end

  def startup_script; <<~EOS
    #!/bin/bash
    export PYTHONPATH="#{libexec}/lib/python2.7/site-packages:$PYTHONPATH"
    python "#{libexec}/Headphones.py" --datadir="#{etc}/headphones" "$@"
    EOS
  end

  def install
    # TODO: strip down to the minimal install.
    libexec.install Dir["*"]

    ENV["CHEETAH_INSTALL_WITHOUT_SETUPTOOLS"] = "1"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec)
      end
    end

    (bin/"headphones").write(startup_script)
  end

  def caveats; <<~EOS
    Headphones defaults to port 8181.
  EOS
  end

  plist_options :manual => "headphones"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/headphones</string>
        <string>-q</string>
        <string>-d</string>
        <string>--nolaunch</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    assert_match "Music add-on", shell_output("#{bin}/headphones -h")
  end
end
