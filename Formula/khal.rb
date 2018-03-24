class Khal < Formula
  include Language::Python::Virtualenv

  desc "CLI calendar application"
  homepage "https://lostpackets.de/khal/"
  url "https://github.com/pimutils/khal.git",
      :tag => "v0.9.8",
      :revision => "b03df58c129f99a35ba74cda0fbc253eb47cfeac"
  revision 3
  head "https://github.com/pimutils/khal.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ffd6f7d7477232bbb242943a4dfb11d868eb940007d616220d882fd14b8ce690" => :high_sierra
    sha256 "1810d0b209145b5428fc3607e3ac2c413bd5a0abdcbd85fe89fa7a18c25a6ee1" => :sierra
    sha256 "3de7be1fcf7b3595cdc6460b994cdfeae03c4c512ee7da6a2cbaafa62db27698" => :el_capitan
  end

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"
    (testpath/".calendar/test/01ef8547.ics").write <<~EOS
      BEGIN:VCALENDAR
      VERSION:2.0
      BEGIN:VEVENT
      DTSTART;VALUE=DATE:20130726
      SUMMARY:testevent
      DTEND;VALUE=DATE:20130727
      LAST-MODIFIED:20130725T142824Z
      DTSTAMP:20130725T142824Z
      CREATED:20130725T142824Z
      UID:01ef8547
      END:VEVENT
      END:VCALENDAR
    EOS
    (testpath/".config/khal/config").write <<~EOS
      [calendars]
      [[test]]
      path = #{testpath}/.calendar/test/
      color = light gray
      [sqlite]
      path = #{testpath}/.calendar/khal.db
      [locale]
      firstweekday = 0
      [default]
      default_calendar = test
    EOS
    system "#{bin}/khal", "--no-color", "search", "testevent"
  end
end
