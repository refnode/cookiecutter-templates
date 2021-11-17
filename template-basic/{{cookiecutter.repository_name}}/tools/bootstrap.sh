#!/bin/sh


if ! test -f .env
then
  cp -a .env.template .env
fi

if test -f .commit.template
then
  git config commit.template .commit.template
fi
