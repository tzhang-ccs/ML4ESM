def fun(STATE):
    #print(STATE['a'])
    a_new = STATE['a'] + STATE['b'] + STATE['c'] + STATE['d']
    STATE['a_new'] = a_new
