class Logentries < Formula
  desc "Utility for access to logentries logging infrastructure"
  homepage "https://logentries.com/doc/agent/"
  url "https://github.com/logentries/le/archive/v1.4.39.tar.gz"
  sha256 "779322c22bb3008d8c74dd51ba6c5eb8cb99e3cbd709d7e37675d3722aff67a9"
  head "https://github.com/logentries/le.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e5bd33211b07911f1b7aae9b806447b2768b474a382865b2a5a1da3d4e7b5bf" => :el_capitan
    sha256 "69e2a7f5a5b79be9464087cc60086ea81beb1049cca6ecaffa64de0b96799340" => :yosemite
    sha256 "e0e9053d47f6c72c8c6fddfc72183b84e78c5586d47d32eb9cc39aea4beb57a0" => :mavericks
  end

  conflicts_with "le", :because => "both install a le binary"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  plist_options :manual => "le monitor"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
        <string>#{opt_bin}/le</string>
        <string>monitor</string>
        </array>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    shell_output("#{bin}/le --help", 4)
  end
end
