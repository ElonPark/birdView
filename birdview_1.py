# -*- coding: UTF-8 -*-
import pprint

def string_to_set(str):
    removeEnter = str.replace('\n', '')
   
    if ' ' in removeEnter:
        hobbySet = filter(lambda x: x != ' ', removeEnter.split(' '))

        return set(hobbySet)

    return set()


def matching_couples():
    #커플 목록
    couples = list()

    with open("testdata.txt", "r") as file:
    #with open("버드뷰_500000x10.txt", "r") as file:
        raw_text = file.readlines()
   
        for i in range(len(raw_text)):
            for j in range(len(raw_text)):
                nextC = j + 1

                now = string_to_set(raw_text[i])
                nextSet = string_to_set(raw_text[j])


                #공통된 취미만 합침
                coupleSet = list(now & nextSet)

                if len(coupleSet) > 0:
                    coupleTuple = (i, j, coupleSet)
                    couples.append(coupleTuple)

    return couples


def printCouple(maxCount):
    coupleStr = ""

    for i in couples:
        hobbyCount = len(i[2])

        if hobbyCount < maxCount:
            continue

        if coupleStr is "":
            coupleStr = "{}-{}".format(i[0], i[1])
        else:
            #일치하는 취미 갯수가 가장 많은 커플과 동일한 경우
            if hobbyCount == maxCount:
                coupleStr += ", {}-{}".format(i[0], i[1])
            else:
                coupleStr += "\n{}-{}".format(i[0], i[1])

    print(coupleStr)


if __name__ == '__main__':
    #커플 목록
    couples = matching_couples()

    #일치하는 취미 갯수로 역순으로 정렬
    couples = sorted(couples, key=lambda couple: len(couple[2]), reverse=True)

    #가장 많이 일치하는 취미 갯수
    _, _, hobbys = couples[0]
    maxCount = len(hobbys)

    printCouple(maxCount)

