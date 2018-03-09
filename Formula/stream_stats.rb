class StreamStats < Formula
  desc "Output statistics about data from stdin while redirecting the data to stdout"
  homepage "https://github.com/ddrscott/stream_stats"
  url "https://github.com/ddrscott/stream_stats/archive/v0.1.0.zip"
  sha256 "9ed73d43e932bd46adbfbf2c0fd15f2a761f28dd85837db8da1015661f9de180"

  bottle do
    sha256 "93e41ce4ca7e71ec9d5f57c6558cbf9c3a470d428f108e26f92f116744ccc50b" => :high_sierra
    sha256 "2fe02eaffc22170831050395d94db9b4c15daa307e31734e058593bd0ad1ee97" => :sierra
    sha256 "0240b8cca8357b9b6526746fe3cf77b346f145f8ffea109ba6ba8d918e593a32" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/stream_stats"
  end

  test do
    system "head -100 /dev/random | #{bin/"stream_stats"} > /dev/null"
  end
end
