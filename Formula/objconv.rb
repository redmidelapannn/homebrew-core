class Objconv < Formula
  desc "Object file converter and disassembler"
  homepage "http://www.agner.org/optimize/#objconv"
  url "http://www.agner.org/optimize/objconv.zip"
  version "2.42"
  sha256 "01bc452c334e3105a516ffcab854b9af2b71c9505fd05681848b051ebf8337f4"
  bottle do
    cellar :any_skip_relocation
    sha256 "27226605d0241f18bd88a8525318a14f6944791a655336e192b90577b109378d" => :sierra
    sha256 "647b9cfbb6240377e8c16dfd342c470030ae81f1edd506d9cef225500e14a8c4" => :el_capitan
    sha256 "c9e1b6a1f8ef191633b438b4c367cef8849eb43d22f3b5c7b6e05322b9c1cb1f" => :yosemite
  end

  def install
    system "unzip", "source.zip",
                    "-dsrc"
    # objconv doesn't have a Makefile, so we have to call
    # the C++ compiler ourselves
    system ENV.cxx, "-o", "objconv",
                    "-O2",
                    *Dir["src/*.cpp"],
                    "--prefix=#{prefix}"
    bin.install "objconv"
  end

  test do
    system "#{bin}/objconv", "-h"
    # TODO: write better tests
  end
end
