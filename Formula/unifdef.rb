class Unifdef < Formula
  desc "Selectively process conditional C preprocessor directives"
  homepage "https://dotat.at/prog/unifdef/"
  url "https://dotat.at/prog/unifdef/unifdef-2.11.tar.gz"
  sha256 "e8483c05857a10cf2d5e45b9e8af867d95991fab0f9d3d8984840b810e132d98"
  head "https://github.com/fanf2/unifdef.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "924a80e6dd9f094aa62abc2184dee7a2d4cef21f66210524c6284acd443c7e75" => :sierra
    sha256 "40e78cdb3c886982eab5a501a5be6f96755a010421f7d74f1298b27f5fb22fb2" => :el_capitan
    sha256 "04c9e79a66b3781777be8eafd4e34fd7c31faeb4b849041d699e28a7210def0c" => :yosemite
  end

  keg_only :provided_by_osx, "the unifdef provided by Xcode cannot compile gevent"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    pipe_output("#{bin}/unifdef", "echo ''")
  end
end
