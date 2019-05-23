class Wtfutil < Formula
  desc "The personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf/archive/v0.10.3.tar.gz"
  sha256 "8afa15a5729bfa5a8d009e3d03423cf7472e797740b92e6f3e66ca8fd05c8454"

  depends_on "go" => :build

  resource "config.yml" do
    url "https://gist.githubusercontent.com/chenrui333/746c939f4a30324f1bbc36c4be38c907/raw/8b5b192c3d50845457b7778e0000ffca5e87212b/config.yml"
    sha256 "edfe1ee724a9625f0fb90f421faf0f0427bcd69183ddda04d24b064f9973951a"
  end

  def install
    # ENV["GOPATH"] = buildpath
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    dir = buildpath/"src/github.com/wtfutil/wtf"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"wtf"
      prefix.install_metafiles
    end
  end

  def caveats; <<~EOS
    Please add a config.yml file to your ~/.config/wtf directory.
    See https://github.com/wtfutil/wtf for details.
    open /Users/rchen/.config/wtf/config.yml: no such file or directory
  EOS
  end

  test do
    (testpath/".config/wtf/config.yml").write <<~EOS
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
  
    system "#{bin}/wtf"
  end
end
