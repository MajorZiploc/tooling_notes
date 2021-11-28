from setuptools import setup, find_packages
# -*- coding: utf-8 -*-

# from distutils.core import setup


try:
    long_description = open("README.rst").read()
except IOError:
    long_description = ""

setup(
    name="py_prac",
    version="0.1.0",
    description="A pip package",
    license="MIT",
    author="manyu",
    packages=find_packages(
        include=['src', 'src.*']),
    install_requires=[
        "autopep8"
    ],
    long_description=long_description,
    classifiers=[
        "Programming Language :: Python",
        "Programming Language :: Python :: 3.8",
    ]
)
