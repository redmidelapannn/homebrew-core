class Wtfutil < Formula
  desc "The personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
    :tag      => "v0.22.0",
    :revision => "bb59d527eb5a60b2cefb8999972287742db729df"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8235aaeab3bcf4c3d87a5084ff3044950b5b24c74f688e385d360780fafe0e81" => :mojave
    sha256 "dd5d0431b6da5cff7405b143d0e422e64fe304f60606318da1ba8e2b91a9b30b" => :high_sierra
    sha256 "821eaa0dab7dad8d84ff10ec26e3acdb43074db5dab04f139416aa92b9dcc95b" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOPROXY"] = "https://gocenter.io"

    dir = buildpath/"src/github.com/wtfutil/wtf"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"wtfutil"
      prefix.install_metafiles
    end
  end

  test do
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
