class Wtfutil < Formula
  desc "The personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
    :tag      => "v0.21.0",
    :revision => "2612194f464b93dd06c17e299dfef54b8be45471"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ab77be2173ee28907e9ae2c7070ff7bf0b90f1cb97263dcb7dc1b4941d184134" => :mojave
    sha256 "51a53b7a918f905b578a902f04093e68f24dc47c5ceaf4fe3255da4f534e2231" => :high_sierra
    sha256 "ec4ac5ab0c099ad7b51fb2016dc9e06d39d11e7acc774df27128779dbc07fd38" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    ENV["GOPROXY"] = "https://gocenter.io"

    dir = buildpath/"src/github.com/wtfutil/wtf"
    dir.install buildpath.children

    cd dir do
      commit = `git rev-parse HEAD`.chomp
      system "go", "build", "-o", "wtfutil", "-ldflags", "-X main.version=#{version} -X main.commit=#{commit}"
      bin.install "wtfutil"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/wtfutil -v").strip
    testconfig = testpath/"config.yml"
    testconfig.write <<~EOS
      wtf:
        colors:
          background: "red"
          border:
            focusable: "darkslateblue"
            focused: "orange"
            normal: "gray"
          checked: "gray"
          highlight:
            fore: "black"
            back: "green"
          text: "white"
          title: "white"
        grid:
          # How _wide_ the columns are, in terminal characters. In this case we have
          # six columns, each of which are 35 characters wide
          columns: [35, 35, 35, 35, 35, 35]

          # How _high_ the rows are, in terminal lines. In this case we have five rows
          # that support ten line of text, one of three lines, and one of four
          rows: [10, 10, 10, 10, 10, 3, 4]
        navigation:
          shortcuts: true
        openFileUtil: "open"
        sigils:
          checkbox:
            checked: "x"
            unchecked: " "
          paging:
            normal: "*"
            selected: "_"
        term: "xterm-256color"
    EOS

    begin
      pid = fork do
        exec "#{bin}/wtfutil", "--config=#{testconfig}"
      end
    ensure
      Process.kill("HUP", pid)
    end
  end
end
