class Minio < Formula
  desc "object storage server compatible with Amazon S3"
  homepage "https://github.com/minio/minio"
  url "https://github.com/minio/minio.git",
    :tag => "RELEASE.2016-08-21T02-44-47Z",
    :revision => "975eb319730c8db093b4744bf9e012356d61eef2"
  version "20160821024447"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "83b50d97f4b80cd32af0bdcf2ac90f538b8da1f4df8241619feb4a08ab77ef72" => :el_capitan
    sha256 "e913c8a4c5e6cd7ac7b694817ba9476dd904b741404300073ac4da49bdbea7be" => :yosemite
    sha256 "0711f2a897e6e9611b96ae598dd8e759a34a5d4c2b371680112ea07115d2be9f" => :mavericks
  end

  depends_on "go" => :build

  def configdir
    etc/"minio"
  end

  def datadir
    var/"minio"
  end

  def install
    ENV["GOPATH"] = buildpath

    clipath = buildpath/"src/github.com/minio/minio"
    clipath.install Dir["*"]

    cd clipath do
      if build.head?
        system "go", "build", "-o", buildpath/"minio"
      else
        release = `git tag --points-at HEAD`.chomp
        version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)\-(\d+)\-(\d+)Z/, 'T\1:\2:\3Z')
        commit = `git rev-parse HEAD`.chomp
        proj = "github.com/minio/minio/"

        system "go", "build", "-o", buildpath/"minio", "-ldflags", <<-EOS.undent
            -X #{proj}/cmd.Version=#{version}
            -X #{proj}/cmd.ReleaseTag=#{release}
            -X #{proj}/cmd.CommitID=#{commit}
            EOS
      end
    end

    bin.install buildpath/"minio"
  end

  def post_install
    # Make sure the datadir exists
    datadir.mkpath
    configdir.mkpath
  end

  plist_options :manual => "minio server"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/minio</string>
        <string>server</string>
        <string>--config-dir=#{configdir}</string>
        <string>--address ":9000"</string>
        <string>#{datadir}</string>
      </array>
      <key>WorkingDirectory</key>
      <string>#{datadir}</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/minio", "version"
  end
end
