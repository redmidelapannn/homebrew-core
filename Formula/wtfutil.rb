class Wtfutil < Formula
  desc "The personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
    :tag      => "v0.10.3",
    :revision => "3eb318324987b6d7bf1daefc9414ac11f7a50ec4"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e4af4ac6cb0ecc9e1b4c82fff57df7fe0638d96d9d859c329fff72e784c5970" => :mojave
    sha256 "889db4f684e4325b0606f6274a1dd743d5a089e6a168a7aba050054376123e89" => :high_sierra
    sha256 "0a8454d3e6a83101342b1c814dd51274826ab22114acacfebb7b509ff169582f" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    dir = buildpath/"src/github.com/wtfutil/wtf"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"wtf"
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
  
    system "#{bin}/wtf", "--config=#{testconfig}"
  end
end
