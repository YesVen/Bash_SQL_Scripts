#!/bin/sh
# This script is for converting Junit3 tests to Junit4 test, the testSuite conversion need to be done mannually
for ii in $(find . -name "Test*.java"); do
    if [[ `grep -m 1 -c "extends *TestCase" ${ii}` -eq 1 ]]; then
        # 'extends TestCase' is problematic because the class (and its sub-classes)
        # may call methods now inside 'Assert.*'. Replacing these calls is error
        # prone as one may have locally defined methods starting with "assert".

        # Just delete the extends testcase:
        sed -i -e "s/[ \t]\+extends *TestCase//" $ii

        # But now there is no super.(tearDown|setUp)
        sed -i -r -e "N; s/[ \t]*super\.setUp\(\);//" $ii
        sed -i -r -e "N; s/[ \t]*super\.tearDown\(\);//" $ii

#        sed -i -r -e "N; s/[ \t]*super\.setUp\(\);//" -i -e "N; s/[ \t]*super\.tearDown..;//" $ii
        sed -i -r ':a;N;$!ba;s/[ \t]*@Override\n[ \t]*(protected|public) void setUp/   protected void setUp/g' $ii
        sed -i -r ':a;N;$!ba;s/[ \t]*@Override\n[ \t]*(protected|public) void tearDown/   protected void tearDown/g' $ii

        if [[ `grep -E -m 1 -c "import (junit.framework|org.junit).Test;" $ii` -eq 0 ]]; then
            sed -i -e "s/import[ \t]\+junit.framework.TestCase;/import org.junit.Test;/" $ii
            sed -i '/import org.junit.Test;/a import static org.junit.Assert.*;' $ii
        
        else
            sed -i -e "s/import junit.framework.TestCase;//" $ii
        fi
        
        
        ### Annotate @Test/@Before/@After only if they are not present in the class already.
        if [[ `grep -m 1 -c "@Test" ${ii}` -eq 0 ]]; then
            sed -i -e "s/^[ \t]*public[ \t]\+void[ \t]\+test/    @Test\n&/" $ii
        fi

        if [[ `grep -m 1 -c "@Before" ${ii}` -eq 0 ]]; then
            sed -i -r -e "s/^[ \t]*(protected|public)[ \t]+void[ \t]+setUp\(\)/    @Before\n   public void setUp()/" $ii
        fi
        if [[ `grep -m 1 -c "@After" ${ii}` -eq 0 ]]; then
            sed -i -r -e "s/^[ \t]*(protected|public)[ \t]+void[ \t]+tearDown\(\)/    @After\n   public void tearDown()/" $ii
        fi
    fi

    ### Fix the any imports left to the new package name
    sed -i -e "s/import junit.framework./import org.junit./" $ii
    
    if [[ `grep -m 1 -c "@Test" $ii` -eq 1 && `grep -m 1 -c "import org.junit.Test;" $ii` -eq 0 ]]; then
        sed -i "0,/package .*;/ s/package .*;/&\n\nimport org.junit.Test;/1" $ii
    fi

    if [[ `grep -m 1 -c "@After" $ii` -eq 1 && `grep -m 1 -c "import org.junit.After;" $ii` -eq 0 ]]; then
        sed -i "0,/package .*;/ s/package .*;/&\nimport org.junit.After;/1" $ii
    fi

    if [[ `grep -m 1 -c "@Before" $ii` -eq 1 && `grep -m 1 -c "import org.junit.Before;" $ii` -eq 0 ]]; then
        sed -i "0,/package .*;/ s/package .*;/&\nimport org.junit.Before;/1" $ii
    fi
    
done
