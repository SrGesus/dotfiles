{ ... }:
{
  /*
    Synopsis: mkIfList condition defaultList

  */
  mkIfList = condition: defaultList: if condition then defaultList else [];
}
