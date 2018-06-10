class Svgcleaner < Formula
  desc "Cleans your SVG files by removing unnecessary data"
  homepage "https://github.com/RazrFalcon/svgcleaner"
  url "https://github.com/RazrFalcon/svgcleaner/archive/v0.9.5.tar.gz"
  sha256 "dcf8dbc8939699e2e82141cb86688b6cd09da8cae5e18232ef14085c2366290c"
  head "https://github.com/RazrFalcon/svgcleaner.git"

  bottle do
    rebuild 1
    sha256 "510a4c5e0f13ac9df67251554fe8c2057b70b59d531e6d7525a1ee71f3b26666" => :high_sierra
    sha256 "fa514744a601ce5db1191704edfe00ef5324b7ce59d08cddd9365a0493732022" => :sierra
    sha256 "fea5b8d0f015452f4a36e2af86c4cdf31f8efc7fbd0e8dd9d66d6b598d0aa933" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    (testpath/"in.svg").write <<~EOS
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <svg
         xmlns="http://www.w3.org/2000/svg"
         version="1.1"
         width="150"
         height="150">
        <rect
           width="90"
           height="90"
           x="30"
           y="30"
           style="fill:#0000ff;fill-opacity:0.75;stroke:#000000"/>
      </svg>
    EOS
    system "#{bin}/svgcleaner", "in.svg", "out.svg"
  end
end
