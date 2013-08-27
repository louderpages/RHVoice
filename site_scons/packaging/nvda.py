# -*- coding: utf-8; mode: Python; indent-tabs-mode: t; tab-width: 4; python-indent: 4 -*-

# Copyright (C) 2013  Olga Yakovleva <yakovleva.o.v@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import os.path
from archiving import archiver

class addon_packager(archiver):
	def __init__(self,name,env,display_name,summary,description,version):
		package_name="{}-{}".format(name,version)
		super(addon_packager,self).__init__(package_name,env,"nvda-addon")
		self.set_string("name",display_name)
		self.set_string("summary",summary)
		self.set_string("description",description)
		self.set_string("author","Olga Yakovleva <yakovleva.o.v@gmail.com>")
		self.set_string("url","http://github.com/Olga-Yakovleva/RHVoice")
		self.set_string("version",version)

	def build_manifest(self,lang=None):
		if lang:
			properties=self.translations[lang]
			outfile=self.outdir.Dir("locale").Dir(lang).File("manifest.ini")
		else:
			properties=self.strings
			outfile=self.outdir.File("manifest.ini")
		lines=list()
		for key,value in properties.iteritems():
			lines.append("{} = {}".format(key,value.encode("utf-8")))
		manifest=self.env.Textfile(outfile,lines,TEXTFILESUFFIX=".ini")
		self.env.Depends(self.outfile,manifest)

	def package(self):
		self.build_manifest()
		for lang in self.translations.iterkeys():
			self.build_manifest(lang)
		return super(addon_packager,self).package()
