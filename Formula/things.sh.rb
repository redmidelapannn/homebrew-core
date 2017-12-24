class ThingsSh < Formula
  desc "Simple read-only comand-line interface to your Things 3 database"
  homepage "https://github.com/AlexanderWillner/things.sh"
  url "https://github.com/AlexanderWillner/things.sh/archive/1.0.tar.gz"
  sha256 "a03a5b1032f48027fd3815422c6dd4633c94b575d8c99db4dad621ff1b1a0310"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ca2def336b2decd9aaf87ea9780d4198ba0958be6573c768762371f25ff3683" => :high_sierra
    sha256 "4ca2def336b2decd9aaf87ea9780d4198ba0958be6573c768762371f25ff3683" => :sierra
    sha256 "4ca2def336b2decd9aaf87ea9780d4198ba0958be6573c768762371f25ff3683" => :el_capitan
  end

  def install
    bin.install "things.sh"
  end

  test do
    system "true" # nothing really to test here
  end
end
