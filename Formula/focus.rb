class Focus < Formula
  desc "CLI implementation of the Pomodoro technique."
  homepage "https://github.com/lfaoro/focus"
  url "https://github.com/lfaoro/focus/archive/v1.0.tar.gz"
  sha256 "ecfa00683bc47eebd6f8603a442c3d1017170ec9b5721de19e682612b27bb52a"

  bottle do
    sha256 "535e161d9d42e8a4ad1a30c2fede3af9c2f6de694e26067f645d2df655ad0cb3" => :sierra
    sha256 "3db3465ad1a2059eb956e99f9711a9526173dda097613e34517270fb530c4bba" => :el_capitan
    sha256 "bf4e32687ca1b893a25c924c6825534d16ebe90067994de388e1f87de3de2b01" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    focus_path = buildpath/"src/github.com/lfaoro/focus/"
    focus_path.install Dir["{*,.git}"]
    cd "src/github.com/lfaoro/focus/" do
      system "go", "build", "-o", bin/"focus", "-v"
    end
  end

  test do
    system "#{bin}/focus", "-v"
  end
end
